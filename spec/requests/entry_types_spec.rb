require 'spec_helper'

describe 'Entry types' do
  before(:all) do
    DatabaseCleaner.clean
    @user = User.make!
    @type = EntryType.make!(user: @user)
  end

  before(:each) do
    login(@user)
  end

  describe 'Regular user logged in' do
    describe 'Index view' do
      before(:each) do
        visit entry_types_path
      end

      it 'visits entry types index' do
        within 'table' do
          expect(current_path).to eq entry_types_path
          ensure_has(@type.name, @type.amount)
        end
      end

      it 'clicks new entry type button' do
        click_link 'New Entry Type'
        expect(current_path).to eq new_entry_type_path
      end

      it 'clicks edit button' do
        within 'table' do
          click_link "edit-entry-type-#{@type.id}"
        end
        expect(current_path).to eq edit_entry_type_path(@type)
      end
    end

    describe 'Create new entry type' do
      before(:each) do
        visit new_entry_type_path
      end

      it 'creates new entry type' do
        within 'form' do
          fill_in 'Name', with: 'Salary'
          fill_in 'Amount', with: 2500
          click_button 'Create Entry type'
        end
        ensure_has('Entry type was successfully created')
        expect(current_path).to eq entry_types_path
      end

      it 'fails to create entry type without a name' do
        within 'form' do
          click_button 'Create Entry type'
        end
        ensure_has("Name can't be blank")
      end
    end

    it 'modifies existing entry type' do
      visit edit_entry_type_path(@type)
      within 'form' do
        fill_in 'Name', with: 'The new name'
        click_button 'Update Entry type'
      end
      ensure_has('Entry type was successfully updated')
    end

    it 'deletes the etry type' do
      @type_to_destroy = EntryType.make!(user: @user)
      visit entry_types_path
      click_link "destroy-entry-type-#{@type_to_destroy.id}"
      ensure_has('Entry type was successfully destroyed')
    end
  end

  describe 'Accessibility' do
    before(:all) do
      @another_user = User.make!
      @another_type = EntryType.make!(user: @another_user)
    end

    it 'only sees own entry types' do
      visit entry_types_path
      expect(page).not_to have_content(@another_type.name)
    end
  end
end
