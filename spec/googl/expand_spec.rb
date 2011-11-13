require 'spec_helper'

# TODO make shared examples
describe Googl::Expand do

  context "when expand any goo.gl short URL" do

    it { Googl.should respond_to(:expand) }

    context "wirh invalid url" do

      use_vcr_cassette "expand_invalid_url", :record => :new_episodes

      it "should return error 404" do
        lambda { Googl.expand('http://goo.gl/blajjddkksijj') }.should raise_error(Exception, /404 Not Found/)
      end

      it "should return error for required url" do
        lambda { Googl.expand }.should raise_error(ArgumentError, /URL to expand is required/)
      end

      it "should return status REMOVED" do
        Googl.expand('http://goo.gl/R7f68').status.should == 'REMOVED'
      end

    end

    context "with valid url" do

      use_vcr_cassette "expand_valid_url", :record => :new_episodes

      subject { Googl.expand('http://goo.gl/7lob') }

      describe "#long_url" do
        it "should return a long url" do
          subject.long_url.should == 'http://jlopes.zigotto.com.br/'
        end
      end

      describe "#status" do
        it "should return a status of url" do
          subject.status.should == 'OK'
        end
      end

      describe "#qr_code" do
        it "should return a url for generate a qr code" do
          subject.qr_code.should == 'http://goo.gl/7lob.qr'
        end
      end

      describe "#info" do
        it "should return url for analytics" do
          subject.info.should == 'http://goo.gl/7lob.info'
        end
      end

      context "with projection" do

        context "full" do

          subject { Googl.expand('http://goo.gl/DWDfi', :projection => :full) }

          describe "#created" do
            let(:element) { subject.created }

            it "should be the time url was shortened" do
              element.should == Time.iso8601("2011-01-13T03:48:10.309+00:00")
            end

          end

          describe "#all_time" do
            let(:element) { subject.analytics.all_time }

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end

            it { element.should respond_to(:short_url_clicks) }
            it { element.should respond_to(:long_url_clicks) }

            it "should rename id to label" do
              element.countries.first.label.should == "BR"
            end
          end

          describe "#month" do
            let(:element) { subject.analytics.month }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end
          end

          describe "#week" do
            let(:element) { subject.analytics.week }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end
          end

          describe "#day" do
            let(:element) { subject.analytics.day }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end
          end

          describe "#two_hours" do
            let(:element) { subject.analytics.two_hours }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end
          end

        end

        context "analytics_clicks" do

          subject { Googl.expand('http://goo.gl/DWDfi', :projection => :analytics_clicks) }

          describe "#all_time" do
            let(:element) { subject.analytics.all_time }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end
          end

          describe "#month" do
            let(:element) { subject.analytics.month }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end
          end

          describe "#week" do
            let(:element) { subject.analytics.week }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end
          end

          describe "#day" do
            let(:element) { subject.analytics.day }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end
          end

          describe "#two_hours" do
            let(:element) { subject.analytics.two_hours }

            describe "#short_url_clicks" do
              it { element.should respond_to(:short_url_clicks) }
            end

            describe "#long_url_clicks" do
              it { element.should respond_to(:long_url_clicks) }
            end
          end

        end

        context "analytics_top_strings" do

          subject { Googl.expand('http://goo.gl/DWDfi', :projection => :analytics_top_strings) }

          describe "#all_time" do
            let(:element) { subject.analytics.all_time }

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end
          end

          describe "#month" do
            let(:element) { subject.analytics.month }

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end
          end

          describe "#week" do
            let(:element) { subject.analytics.week }

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end
          end

          describe "#day" do
            let(:element) { subject.analytics.day }

            describe "#referrers" do
              it { element.should respond_to(:referrers) }
              it { element.referrers.first.should respond_to(:count) }
              it { element.referrers.first.should respond_to(:label) }
            end

            describe "#countries" do
              it { element.should respond_to(:countries) }
              it { element.countries.first.should respond_to(:count) }
              it { element.countries.first.should respond_to(:label) }
            end

            describe "#browsers" do
              it { element.should respond_to(:browsers) }
              it { element.browsers.first.should respond_to(:count) }
              it { element.browsers.first.should respond_to(:label) }
            end

            describe "#platforms" do
              it { element.should respond_to(:platforms) }
              it { element.platforms.first.should respond_to(:count) }
              it { element.platforms.first.should respond_to(:label) }
            end
          end

        end

      end

    end

  end

end
