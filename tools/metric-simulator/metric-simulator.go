package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	yaml "gopkg.in/yaml.v2"
)

type MetricList struct {
	Metrics []MetricConf `yaml:"metrics"`
}

type Sequence struct {
	LabelValues []string `yaml:"label_values"`
	Interval    int      `yaml:"interval"`
	MinVaule    int      `yaml:"min_value"`
	MaxVaule    int      `yaml:"max_value"`
	Value       int      `yaml:"value"`
	Operation   string   `yaml:"operation"`
}

type MetricConf struct {
	Name      string     `yaml:"name"`
	Help      string     `yaml:"help"`
	Type      string     `yaml:"type"`
	LabelKeys []string   `yaml:"label_keys"`
	Sequences []Sequence `yaml:"sequences"`
}

func updateCounterMetric(mc MetricConf, cv *prometheus.CounterVec) {
	for _, s := range mc.Sequences {
		labels := make(map[string]string, len(mc.LabelKeys))
		for idx, key := range mc.LabelKeys {
			labels[key] = s.LabelValues[idx]
		}
		go updateCounter(cv, labels, s.Interval)
	}
}

func updateCounter(cv *prometheus.CounterVec, labels prometheus.Labels, interval int) {
	for {
		cv.With(labels).Inc()
		time.Sleep(time.Second * time.Duration(interval))
	}
}

func updateGuageMetric(mc MetricConf, cv *prometheus.GaugeVec) {
	for _, s := range mc.Sequences {
		go updateGauge(cv, mc.LabelKeys, s)
	}
}

func updateGauge(cv *prometheus.GaugeVec, labelKeys []string, seq Sequence) {
	labels := make(map[string]string, len(labelKeys))
	for idx, key := range labelKeys {
		labels[key] = seq.LabelValues[idx]
	}

	if seq.MaxVaule != 0 {
		cv.With(labels).Set(float64(seq.MaxVaule))
	}

	for {
		switch seq.Operation {
		case "add":
			cv.With(labels).Add(float64(seq.Value))
		case "sub":
			cv.With(labels).Sub(float64(seq.Value))
		case "inc":
			cv.With(labels).Inc()
		case "dec":
			cv.With(labels).Dec()
		default:
			cv.With(labels).Set(1)
		}

		time.Sleep(time.Second * time.Duration(seq.Interval))
	}
}

func main() {
	confFile := os.Getenv("METRIC_CONFIG")
	if confFile == "" {
		log.Fatal("failed to found metric config file")
	}
	config, _ := ioutil.ReadFile(confFile)
	metrics := MetricList{}
	err := yaml.Unmarshal(config, &metrics)
	if err != nil {
		log.Fatal("invalid metric config")
	}
	log.Printf("metrics: %+v\n", metrics)
	for _, m := range metrics.Metrics {
		switch m.Type {
		case "counter":
			cv := prometheus.NewCounterVec(
				prometheus.CounterOpts{
					Name: m.Name,
					Help: m.Help,
				},
				m.LabelKeys,
			)
			err := prometheus.Register(cv)
			if err != nil {
				log.Printf("prometheus.Register: %v\n", err)
			}
			go updateCounterMetric(m, cv)
		case "gauge":
			guage := prometheus.NewGaugeVec(
				prometheus.GaugeOpts{
					Name: m.Name,
					Help: m.Help,
				},
				m.LabelKeys,
			)
			err := prometheus.Register(guage)
			if err != nil {
				log.Printf("prometheus.Register: %v\n", err)
			}
			go updateGuageMetric(m, guage)
		default:
			fmt.Print(m.Type)
		}
	}

	port := os.Getenv("METRIC_PORT")
	if port == "" {
		port = "8080"
	}
	http.Handle("/metrics", promhttp.Handler())
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
