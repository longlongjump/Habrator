require_relative 'spec_helper'
require_relative '../lib/cronify'


describe Cronify do

  let(:cron_data) do
    io = StringIO.open(@cron_str)
    io.rewind
    io
  end

  before :all do
    @cron_str ||= ""
  end

  before :each do
    Cronify.stub(:cron_tasks).and_return(@cron_str)
    Cronify.stub(:sh)
    Cronify.stub(:'`')

    File.stub(:open)
  end

 
  it 'should add tasks group1' do
    File.should_receive(:open).and_yield(cron_data)
    Cronify.push "group1" do |tasks|
      tasks << "* * * *  cd do whatever"
    end

    @cron_str.should include("group1")    
  end

  it 'should add tasks group2' do
    File.should_receive(:open).and_yield(cron_data)
    Cronify.push "group2" do |tasks|
      tasks << "* * * *  cd do whatever"
    end


    @cron_str.should include("group2")
    @cron_str.scan("## group1").length.should == 1
  end


  it 'should delete tasks' do
    io = StringIO.new
    File.should_receive(:open).and_return(io)
    Cronify.pop "group1"

    io.string.should_not include("group1")
    io.string.should include("group2")
  end

end
