/*
 * Copyright The OpenTelemetry Authors
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation
import OpenTelemetrySdk

public class OtlpMetricJsonExporter: MetricExporter {
    // MARK: - Variables declaration
    private var exportedMetrics = [Metric]()
    private var isRunning: Bool = true
    
    // MARK: - Json Exporter helper methods
    public func getExportedMetrics() -> Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest {
        return Opentelemetry_Proto_Collector_Metrics_V1_ExportMetricsServiceRequest
            .with {
                $0.resourceMetrics = MetricsAdapter.toProtoResourceMetrics(metricDataList: exportedMetrics)
            }
    }
    
    public init() {
        
    }
    
    public func export(metrics: [Metric], shouldCancel: (() -> Bool)?) -> MetricExporterResultCode {
        guard isRunning else { return .failureNotRetryable }
        
        exportedMetrics.append(contentsOf: metrics)

        return .success
    }

    public func flush() -> SpanExporterResultCode {
        guard isRunning else { return .failure }
        return .success
    }

    public func reset() {
        exportedMetrics.removeAll()
    }

    public func shutdown() {
        exportedMetrics.removeAll()
        isRunning = false
    }
}
