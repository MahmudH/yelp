require 'spec_helper'

feature 'User can sign in and out' do
  context 'user not signed in and on the homepage' do
    it 'should see a sign in link and a sign up link' do
      visit '/'
      expect(page).to have_link 'Sign in'
      expect(page).to have_link 'Sign up'
    end

    it 'should not see sign out link' do
      visit '/'
      expect(page).not_to have_link 'Sign out'
    end
  end
  context 'user signed in on the homepage' do
    before do
      visit '/'
      click_link 'Sign up'
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'testtest'
      fill_in 'Password confirmation', with: 'testtest'
      click_button 'Sign up'
      Restaurant.create name: 'KFC'
    end

    it 'should see sign out link' do
      visit '/'
      expect(page).to have_link 'Sign out'
    end

    it 'should not see a sign in link and a sign up link' do
      visit '/'
      expect(page).not_to have_link 'Sign in'
      expect(page).not_to have_link 'Sign up'
    end

    it 'should not be able to delete restaurants they have not created' do
      visit '/'
      click_link 'Delete KFC'
      expect(page).to have_content 'You cannot delete this restaurant'
    end
  end

  context 'user not signed in' do
    it 'cannot create restaurants' do
      visit '/'
      click_link 'Add a restaurant'
      expect(page).not_to have_button 'Create Restaurant'
    end
  end

  context 'user cannot leave a review' do
     before do
      visit '/'
      click_link 'Sign up'
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'testtest'
      fill_in 'Password confirmation', with: 'testtest'
      click_button 'Sign up'
      visit'/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      visit '/'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'good'
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end

     it 'can only leave one review per restaurant' do
       visit '/'
       click_link 'Review KFC'
       expect(page).to have_content 'Cannot review this restaurant more than once'
       expect(current_path).to eq '/'
     end
  end
end
