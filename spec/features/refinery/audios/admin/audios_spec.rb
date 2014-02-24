# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Audios" do
    describe "Admin" do
      describe "audios" do
        refinery_login_with :refinery_user

        describe "audios list" do
          before do
            FactoryGirl.create(:audio, :title => "UniqueTitleOne")
            FactoryGirl.create(:audio, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.audios_admin_audios_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.audios_admin_audios_path

            click_link "Add New Audio"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Audios::Audio.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Title can't be blank")
              Refinery::Audios::Audio.count.should == 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:audio, :title => "UniqueTitle") }

            it "should fail" do
              visit refinery.audios_admin_audios_path

              click_link "Add New Audio"

              fill_in "Title", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Audios::Audio.count.should == 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:audio, :title => "A title") }

          it "should succeed" do
            visit refinery.audios_admin_audios_path

            within ".actions" do
              click_link "Edit this audio"
            end

            fill_in "Title", :with => "A different title"
            click_button "Save"

            page.should have_content("'A different title' was successfully updated.")
            page.should have_no_content("A title")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:audio, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.audios_admin_audios_path

            click_link "Remove this audio forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Audios::Audio.count.should == 0
          end
        end

      end
    end
  end
end
