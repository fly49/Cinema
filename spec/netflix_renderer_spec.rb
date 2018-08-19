require 'netflix'
require 'rspec-html-matchers'
require_relative '../netflix_renderer'

describe Cinema::NetflixRenderer do
  include RSpecHtmlMatchers
  before do
    netflix = Cinema::Netflix.new('movies.txt')
    Cinema::NetflixRenderer.new(netflix).render_to('page.html','html_pages/')
  end
    
  let(:rendered) { open('html_pages/page.html').read }
  it 'should contain columns with movie attributes' do
    expect(rendered).to have_tag('tr') do
      with_tag "td", :text => 'Title:' 
      with_tag 'td', :text => 'Year:'
      with_tag 'td', :text => 'Country:'
      with_tag 'td', :text => 'Date:'
      with_tag 'td', :text => 'Genre:'
      with_tag 'td', :text => 'Duration:'
      with_tag 'td', :text => 'Director:'
      with_tag 'td', :text => 'Rating:'
      with_tag 'td', :text => 'Cast:'
    end
  end
  it 'should support UTF-8' do
    expect(rendered).to have_tag('meta', :with => { :charset => 'UTF-8'})
  end
end