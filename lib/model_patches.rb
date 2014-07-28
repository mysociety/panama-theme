# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    OutgoingMessage.class_eval do
        # Add intro paragraph to new request template
        def default_letter
            return nil if self.message_type == 'followup'
            #"If you uncomment this line, this text will appear as default text in every message"
        end
    end

    InfoRequest.instance_eval do
        def count_total_by_year(year, public_body=nil)
            start_date, end_date = parse_annual_start_and_end_date(year)
            select_count(nil, start_date, end_date, public_body)
        end

        def count_total_by_quarter_and_year(quarter_no, year, public_body=nil)
            start_date, end_date = parse_quarter_start_and_end_date(quarter_no, year)
            select_count(nil, start_date, end_date, public_body)
        end

        def count_total_by_month_and_year(month_no, year, public_body=nil)
            start_date, end_date = parse_start_and_end_date(month_no, year)
            select_count(nil, start_date, end_date, public_body)
        end

        def count_unanswered_by_year(year, public_body=nil)
            start_date, end_date = parse_annual_start_and_end_date(year)
            select_count("waiting_response", start_date, end_date, public_body)
        end

        def count_unanswered_by_quarter_and_year(quarter_no, year, public_body=nil)
            start_date, end_date = parse_quarter_start_and_end_date(quarter_no, year)
            select_count("waiting_response", start_date, end_date, public_body)
        end

        def count_unanswered_by_month_and_year(month_no, year, public_body=nil)
            start_date, end_date = parse_start_and_end_date(month_no, year)
            select_count("waiting_response", start_date, end_date, public_body)
        end

        def count_successful_by_year(year, public_body=nil)
            start_date, end_date = parse_annual_start_and_end_date(year)
            select_count(["successful", "partially_successful"], start_date, end_date, public_body)
        end

        def count_successful_by_quarter_and_year(quarter_no, year, public_body=nil)
            start_date, end_date = parse_quarter_start_and_end_date(quarter_no, year)
            select_count(["successful", "partially_successful"], start_date, end_date, public_body)
        end

        def count_successful_by_month_and_year(month_no, year, public_body=nil)
            start_date, end_date = parse_start_and_end_date(month_no, year)
            select_count(["successful", "partially_successful"], start_date, end_date, public_body)
        end

        def count_rejected_by_year(year, public_body=nil)
            start_date, end_date = parse_annual_start_and_end_date(year)
            select_count("rejected", start_date, end_date, public_body)
        end

        def count_rejected_by_quarter_and_year(quarter_no, year, public_body=nil)
            start_date, end_date = parse_quarter_start_and_end_date(quarter_no, year)
            select_count("rejected", start_date, end_date, public_body)
        end

        def count_rejected_by_month_and_year(month_no, year, public_body=nil)
            start_date, end_date = parse_start_and_end_date(month_no, year)
            select_count("rejected", start_date, end_date, public_body)
        end

        def count_overdue_by_year(year, public_body=nil)
            start_date, end_date = parse_annual_start_and_end_date(year)
            unanswered = []
            if public_body
                unanswered = InfoRequest.where(
                    :described_state => "waiting_response",
                    :created_at => start_date.beginning_of_day..end_date.end_of_day,
                    :public_body_id => public_body.id
                )
            else
                unanswered = InfoRequest.where(
                    :described_state => "waiting_response",
                    :created_at => start_date.beginning_of_day..end_date.end_of_day
                )
            end
            unanswered.select { |x| x.created_at > x.date_response_required_by }.count
        end

        def count_overdue_by_quarter_and_year(quarter_no, year, public_body=nil)
            start_date, end_date = parse_quarter_start_and_end_date(quarter_no, year)
            unanswered = []
            if public_body
                unanswered = InfoRequest.where(
                    :described_state => "waiting_response",
                    :created_at => start_date.beginning_of_day..end_date.end_of_day,
                    :public_body_id => public_body.id
                )
            else
                unanswered = InfoRequest.where(
                    :described_state => "waiting_response",
                    :created_at => start_date.beginning_of_day..end_date.end_of_day
                )
            end
            unanswered.select { |x| x.created_at > x.date_response_required_by }.count
            unanswered.select { |x| x.created_at > x.date_response_required_by }.count
        end

        def count_overdue_by_month_and_year(month_no, year, public_body=nil)
            start_date, end_date = parse_start_and_end_date(month_no, year)
            unanswered = []
            if public_body
                unanswered = InfoRequest.where(
                    :described_state => "waiting_response",
                    :created_at => start_date.beginning_of_day..end_date.end_of_day,
                    :public_body_id => public_body.id
                )
            else
                unanswered = InfoRequest.where(
                    :described_state => "waiting_response",
                    :created_at => start_date.beginning_of_day..end_date.end_of_day
                )
            end
            unanswered.select { |x| x.created_at > x.date_response_required_by }.count
            unanswered.select { |x| x.created_at > x.date_response_required_by }.count
        end


        protected

        def select_count(state, start_date, end_date, public_body)
            if state
                if public_body
                    InfoRequest.where(
                        :described_state => state,
                        :created_at => start_date.beginning_of_day..end_date.end_of_day,
                        :public_body_id => public_body.id
                    ).count
                else
                    InfoRequest.where(
                        :described_state => state,
                        :created_at => start_date.beginning_of_day..end_date.end_of_day
                    ).count
                end
            else
                if public_body
                    InfoRequest.where(
                        :created_at => start_date.beginning_of_day..end_date.end_of_day,
                        :public_body_id => public_body.id
                    ).count
                else
                    InfoRequest.where(
                        :created_at => start_date.beginning_of_day..end_date.end_of_day
                    ).count
                end
            end
        end

        def parse_quarter_start_and_end_date(quarter_no, year)
            start_month= (quarter_no-1) * 3 + 1
            end_month = quarter_no * 3
            start_date = Date.parse("#{year}-#{start_month}-01")
            end_date = Date.parse("#{year}-#{end_month}-01")
            end_date = ((end_date +1) >> 1) - 2
            [start_date, end_date]
        end

        def parse_start_and_end_date(month_no, year)
            start_date = Date.parse("#{year}-#{month_no}-01")
            end_date = ((start_date +1) >> 1) - 2
            [start_date, end_date]
        end

        def parse_annual_start_and_end_date(year)
            [Date.parse("#{year}-01-01"), Date.parse("#{year}-12-31")]
        end
    end
end
