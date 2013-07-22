# encoding: utf-8
require 'spec_helper'

describe ScopeComposer::Model do
  subject do
    class TestClass
      include ScopeComposer::Model
      
      has_scope_composer
      scope :say_hi, ->(t){ 'hi' }
      scope_helper :helper_method, ->(t){ 'hi' }
      
      scope_composer_for :search
      
      search_scope :limit
      search_scope :offset, prefix: true
      search_helper :tester, ->(t){ t.to_i }
      
    end
    TestClass
  end
  
  it { should respond_to :scope_composer_for }
  it { should respond_to :scope_scope }
  it { should respond_to :scope }
  it { should respond_to :say_hi }
  
  it { should respond_to :search_scope }
  it { should respond_to :search_helper }
  it { should respond_to :limit }
  it { should respond_to :offset_search }
  it { should_not respond_to :tester }

  it "should define a scope helper" do
    TestClass.say_hi('hi').should respond_to :helper_method
  end

end