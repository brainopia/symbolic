require File.expand_path('../spec_helper', __FILE__)

describe Symbolic do
  let(:var) { Object.new.extend Symbolic }

  it 'should handle unary plus' do
    (+var).should == var
  end

  it 'should handle unary minus' do
    Symbolic::Factors.should_receive(:add).with(var, -1).and_return(:negative_value)
    (-var).should == :negative_value
  end

  it 'should handle binary plus' do
    Symbolic::Summands.should_receive(:add).with(var, :other_var).and_return(:result)
    (var + :other_var).should == :result
  end

  it 'should handle binary minus' do
    Symbolic::Summands.should_receive(:subtract).with(var, :other_var).and_return(:result)
    (var - :other_var).should == :result
  end

  it 'should handle multiplication' do
    Symbolic::Factors.should_receive(:add).with(var, :other_var).and_return(:result)
    (var * :other_var).should == :result
  end

  it 'should handle division' do
    Symbolic::Factors.should_receive(:subtract).with(var, :other_var).and_return(:result)
    (var / :other_var).should == :result
  end

  it 'should handle exponentation' do
    Symbolic::Factors.should_receive(:power).with(var, :other_var).and_return(:result)
    (var ** :other_var).should == :result
  end

  it 'should delegate string representation to Printer' do
    Symbolic::Printer.should_receive(:print).with(var).and_return(:string)
    var.to_s.should == :string
  end

  it 'should redefine inspect' do
    var.should_receive(:to_s).and_return(:string)
    var.inspect.should == "Symbolic(string)"
  end
end
