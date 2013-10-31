# encoding: utf-8
require 'spec_helper'

describe ScopeComposer::Model do

  class ScopeComposerModelTest
    include ScopeComposer::Model
  
    has_scope_composer
    scope :say_hi, ->(t){ scope_attributes[:say_hi] = t  }
    scope_helper :helper_method, ->(t){ 'hi' }
  
    scope_composer_for :search
    search_scope :select
    search_scope :limit
    search_scope :offset, prefix: true
    search_helper :tester, ->(t){ t.to_i }
  
  end
  
  let(:scope){ ScopeComposerModelTest }
  subject{ scope }
  
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
    ScopeComposerModelTest.say_hi('hi').should respond_to :helper_method
  end

  it "should define a scope helper" do
    t = ScopeComposerModelTest.say_hi('test')
    t.say_hi.should eq 'test'
  end
  
  describe ".search_scope" do
    let(:scope){ ScopeComposerModelTest.search_scope.new }
    subject{ scope }
    before(:each){ scope.limit(10) }
    
    its(:scope_attributes){ should eq({ limit: 10 }) }
    its(:attributes){ should eq({}) }
    
    describe "#select" do
      before(:each){ scope.select(:key1, :key2, :key3) }
    
      its(:scope_attributes){ should eq({ limit: 10, select: [:key1, :key2, :key3] }) }
      
      its(:limit){ should eq 10 }
      its(:select){ should eq [:key1, :key2, :key3] }
    end
    
    describe "#where" do
      before(:each){ scope.where( id: 20 ) }
    
      its(:scope_attributes){ should eq({ limit: 10 }) }
      its(:attributes){ should eq({ id: 20 }) }
    end
    
    describe "#scoped" do
      before(:each){ scope.where( id: 20 ) }
      subject{ scope.scoped }
      
      its(:attributes){ should eq({ id: 20 }) }
      
      it "should not alter the original object" do
        scope.where( id: 30 )
        subject.where( id: 40 )
        scope.attributes.should eq({id: 30})
        subject.attributes.should eq({id: 40})
      end
      
      
    end
    
  end
  
  describe ".scope" do
    it "should return self" do
      subject.limit(1).where( id: 1 ).class.should eq ScopeComposerModelTest::SearchScope
    end
  end
  
end