require 'spec_helper'

describe "while cart is empty" do
  before {visit root_path}
  subject {page}

  it {should_not have_content("Courses in cart")}
  it {should have_selector(:link_or_button, 'Add Course')}
  it {should_not have_selector(:link_or_button, "Reset")}
  it {should_not have_selector(:link_or_button, "Generate Schedule")}
end

describe "after cart has courses" do
  before do
    visit root_path
    fill_in("Course code", :with => "ENG1112")
    click_button('Add Course')
  end
  subject {page}

  it {should have_content("Courses in cart")}
  it {should have_selector(:link_or_button, 'Add Course')}
  it {should have_selector(:link_or_button, "Reset")}
  it {should have_selector(:link_or_button, "Generate Schedule")}
end

describe "adding a course to the cart" do
  subject {page}
  before do
    visit root_path
  end

  describe "adding a valid course" do
    before do
      fill_in("Course code", :with => "ENG1112")
      click_button('Add Course')
    end

      it {should have_content('ENG1112')}
  end

  describe "adding an invalid course" do
    before do
      fill_in("Course code", :with => "abc12345")
      click_button('Add Course')
    end

    it {should_not have_content('abc12345')}
    it { should have_content('Invalid course code') }
  end

  describe "adding the same course more than once" do
    before do
      fill_in("Course code", :with => "ENG1112")
      click_button('Add Course')
      fill_in("Course code", :with => "ENG1112")
      click_button('Add Course')
    end

    it {should have_content('ENG1112', :count => 1)}
    it { should have_content('This course is already included') }
  end

  describe "trying to add more than nine courses" do
    before do
      for i in 1..10 do
        fill_in("Course code", :with => "ABC" + (1000 + i).to_s)
        click_button('Add Course')
      end
    end

      it {should_not have_content('ABC1010')}
      it {should have_content('ABC', :count => 9)}
      it {should have_content('No more than 9 courses are allowed') }
  end
end
