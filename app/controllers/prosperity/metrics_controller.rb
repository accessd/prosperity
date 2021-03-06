require_dependency "prosperity/application_controller"

module Prosperity
  class MetricsController < ApplicationController
    before_filter :get_metric, only: [:show, :data]

    def index
      @metrics = MetricFinder.all
    end

    def show
      respond_to do |format|
        format.html
        format.json do
          render json: {
            id: @metric.id,
            title: @metric.title,
            options: @metric.options.map do |k, option|
              {key: k}
            end,
            extractors: @metric.extractors.map do |ext|
              {
                key: ext.key,
                url: data_metric_path(id: @metric.id,
                                      extractor: ext.key,
                                      option: option,
                                      period: period,
                                      start_time: start_time,
                                      end_time: end_time),

              }
            end
          }
        end
      end
    end

    def data
      ext_name = params.fetch(:extractor, "interval")
      ext_klass = Metric.extractors.fetch(ext_name) do
        render_json_error "Could not find extractor #{ext_name} for #{@metric}. Possible values are #{Metric.extractors.keys.join(", ")}.", 404
        return
      end

      p = Prosperity::Periods::ALL.fetch(period)
      ext = ext_klass.new(@metric, option, start_time, end_time, p)

      data = begin
        ext.to_a
      rescue => e
        logger.error "#{e}\n#{e.backtrace.join("\n")}"
        render_json_error "An exception occured while retrieving data from #{@metric}. #{e}"
        return
      end

      json = {
        data: data,
        key: ext.key,
        uid: ext.uid,
        label: ext.label,
        start_time: p.actual_start_time(start_time).iso8601,
        end_time: p.actual_end_time(end_time).iso8601,
        period_milliseconds: p.duration * 1000
      }
      render json: json
    end
    private 

    def get_metric
      @metric = MetricFinder.find_by_name(params.fetch(:id)).new
    rescue NameError
      render_json_error("Could not find metric #{params.fetch(:id)}", 404)
    end

    def option
      params.fetch(:option, 'default')
    end
    helper_method :option
  end
end
