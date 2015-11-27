require 'rails_helper'

feature 'reviewing' do
     before do
      visit '/'
      click_link 'Sign up'
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
      Restaurant.create name: 'KFC'
    end

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so good'
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'so good'
  end

  context 'deleting reviews' do
    before do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'so good'
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end

      it 'can see the delete link for reviews' do
        visit '/'
        expect(page).to have_content 'Delete KFC Review'
      end
     end

  context 'can only delete reviews they created' do
    before do
      visit'/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Lahore'
      click_button 'Create Restaurant'
      visit '/restaurants'
      click_link 'Review Lahore'
      fill_in 'Thoughts', with: 'so good'
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Sign out'
      visit '/'
      click_link 'Sign up'
      fill_in 'Email', with: 'test2@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
    end

    it 'should not be able to see delete review link' do
      visit '/'
      expect(page).not_to have_link 'Delete Lahore Review'
    end
  end

  def leave_review(thoughts,rating)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    click_link 'Sign out'
    visit '/'
    click_link 'Sign up'
    fill_in 'Email', with: 'test2@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end

end
