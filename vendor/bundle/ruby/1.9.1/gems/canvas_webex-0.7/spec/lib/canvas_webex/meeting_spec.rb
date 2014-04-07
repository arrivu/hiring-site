require 'spec_helper'

describe CanvasWebex::Meeting do
  let(:client) {CanvasWebex::Service.new('proserv_instructure', 'foo', '123', 'instructure', nil, 'test')}
  subject{CanvasWebex::Meeting.retrieve(123, client)}

  before(:each) do
    stub_call('get_meeting')
  end

  it 'returns the meeting name' do
    subject.conf_name.should == "test"
  end

  it 'returns the meeting key' do
    subject.meeting_key.should == "807833538"
  end

  it 'returns the start date' do
    subject.start_date.should == "10/22/2013 10:59:19"
  end

  it 'returns the host_joined value' do
    subject.host_joined.should == "false"
  end

  it 'returns the status' do
    subject.status.should == "NOT_INPROGRESS"
  end

  it 'parses a cisco timestamp' do
    stub_call('list_timezones')
    ts = CanvasWebex::Meeting.parse_time_stamp(4, '01/26/2006 21:00:00', client)
    ts.to_s.should == '2006-01-26T21:00:00-08:00'
  end

end