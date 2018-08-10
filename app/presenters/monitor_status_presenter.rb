# This presenter class provides all data needed by the view that monitors status of authorities.
class MonitorStatusPresenter

  # @param current_summary [ScenarioRunSummary] summary status of the latest run of test scenarios
  # @param current_data [Array<Hash>] current set of failures for the latest test run, if any
  # @param historical_summary_data [Array<Hash>] summary of past failuring runs per authority to drive chart
  def initialize(current_summary:, current_failure_data:, historical_summary_data:, performance_data:)
    @current_summary = current_summary
    @current_failure_data = current_failure_data
    @historical_summary_data = historical_summary_data
    @performance_data = performance_data
  end

  # @return [String] date of last test run
  def last_updated
    @current_summary.run_dt_stamp.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%y - %I:%M %p")
  end

  # @return [String] date of first recorded test run
  def first_updated
    ScenarioRunRegistry.first.dt_stamp.in_time_zone("Eastern Time (US & Canada)").strftime("%m/%d/%y - %I:%M %p")
  end

  # @return [Integer] number of loaded authorities
  def authorities_count
    @current_summary.authority_count
  end

  # @return [Integer] number of authorities with failing tests in the latest test run
  def failing_authorities_count
    @current_failure_data.map { |f| f[:authority_name] }.uniq.count
  end

  # @return [String] css style class representing whether all tests passed or any failed
  def authorities_count_style
    failures? ? 'status-bad' : 'status-good'
  end

  # @return [Integer] number of tests in the latest test run
  def tests_count
    @current_summary.total_scenario_count
  end

  # @return [Integer] number of passing tests in the latest test run
  def passing_tests_count
    @current_summary.passing_scenario_count
  end

  # @return [Integer] number of failing tests in the latest test run
  def failing_tests_count
    @current_summary.failing_scenario_count
  end

  # @return [String] css style class representing whether all tests passed or any failed
  def failing_tests_style
    failures? ? 'status-bad' : 'status-good'
  end

  # @return [Array<Hash>] A list of failures data in the latest test run, if any
  # @example
  #   [ { status: :FAIL,
  #       status_label: 'X',
  #       authority_name: 'LOCNAMES_LD4L_CACHE',
  #       subauthority_name: 'person',
  #       service: 'ld4l_cache',
  #       action: 'search',
  #       url: '/qa/search/linked_data/locnames_ld4l_cache/person?q=mark twain&maxRecords=4',
  #       err_message: 'Exception: Something went wrong.' }, ... ]
  def failures
    @current_failure_data
  end

  # @return [Boolean] true if failure data exists for the latest test run; otherwise false
  def failures?
    failing_tests_count.positive?
  end

  # @return [Array<Hash>] historical test data to be displayed
  # @example
  #   [ [ 'agrovoc', 24, 0 ],
  #     [ 'geonames_ld4l_cache', 24, 2 ] ... ]
  def historical_summary
    @historical_summary_data
  end

  # @return [Boolean] true if historical test data exists; otherwise false
  def history?
    return true if @historical_summary_data.present?
    false
  end

  # @return [String] the name of the css style class to use for the status cell based on the status of the scenario test.
  def status_style_class(status)
    "status-#{status[:status].to_s}"
  end

  # @return [String] the name of the css style class to use for the status cell based on the status of the scenario test.
  def status_label(status)
    case status[:status]
      when :good
        ScenarioRunHistory::GOOD_MARKER
      when :bad
        ScenarioRunHistory::BAD_MARKER
      when :unknown
        ScenarioRunHistory::UNKNOWN_MARKER
    end
  end
end
