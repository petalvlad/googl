require 'spec_helper'

describe Googl::Shorten do

  context "when request new short url" do

    it { Googl.should respond_to(:shorten) }

    context "with invalid url" do

      it "should return error for required url" do
        expect { Googl.shorten }.to raise_error(ArgumentError, "URL to shorten is required")
      end

    end

    context "with valid url" do

      use_vcr_cassette "shorten_valid_url", :record => :new_episodes

      subject { Googl.shorten('http://www.zigotto.com') }

      describe "#short_url" do
        it "should return a short URL" do
          subject.short_url.should == 'http://goo.gl/ump4S'
        end
      end

      describe "#long_url" do
        it "should return a long url" do
          subject.long_url.should == 'http://www.zigotto.com/'
        end
      end

      describe "#qr_code" do
        it "should return a url for generate a qr code" do
          subject.qr_code.should == 'http://goo.gl/ump4S.qr'
        end
      end

      describe "#info" do
        it "should return url for analytics" do
          subject.info.should == 'http://goo.gl/ump4S.info'
        end
      end

    end

  end

end
