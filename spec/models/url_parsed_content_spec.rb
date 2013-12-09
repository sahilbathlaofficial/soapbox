require 'spec_helper'

describe URLParsedContent do
  
  describe 'validation' do
    describe 'presence of ' do
    
      context 'post_id' do
        it { should  validate_presence_of(:post_id) }
      end
    
    end

    describe 'format of' do
      context 'url' do
        it { should allow_value('http://www.ruby.com', 'https://www.ruby.com' ,'http://www.ruby.com?id=2&x=y').for(:url) }
        it { should_not allow_value('ruby.com').for(:url) } 
        it { should_not allow_value('ruby').for(:url) } 
        it { should_not allow_value('xyz://ruby.com').for(:url) } 
        it { should_not allow_value('xyz').for(:url) } 
      end
    end
  end

  describe 'association' do
    describe 'belongs to ' do
    
      context 'post' do
        it { should  belong_to(:post) }
      end
    
    end
  end

end
