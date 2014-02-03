require 'spec_helper'

describe 'Post #create' do 
  it 'test' do 
    expect(response).to render_template(:new)
  end

end
