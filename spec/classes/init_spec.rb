require 'spec_helper'
describe 'amazon_ses' do

  context 'with defaults for all parameters' do
    it { should contain_class('amazon_ses') }
  end
end
