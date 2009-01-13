require 'pathname'
__dir__ = Pathname(__FILE__).dirname.expand_path

require __dir__.parent.parent + 'spec_helper'
require __dir__ + 'spec_helper'

if HAS_SQLITE3 || HAS_MYSQL || HAS_POSTGRES
  describe GitOperation do
    before :each do
      @operation = GitOperation.new
    end

    describe "with no name set" do
      before :each do
        @operation.name = nil
        @operation.valid?
      end

      it "is not valid" do
        @operation.should_not be_valid
      end

      it "is not valid for any particular purpose of validation" do
        @operation.should_not be_valid_for_committing
      end

      it "points to blank name in the error message" do
        @operation.errors.on(:name).should include('Name must not be blank')
      end
    end
  end



  # keep in mind any ScmOperation has a default value for brand property
  # so it is used
  describe GitOperation do
    before :each do
      @operation = GitOperation.new(:network_connection => true,
                                    :clean_working_copy => true,
                                    :message            => "I did it! I did it!! Hell yeah!!!")
    end

    describe "without explicitly specified committer name" do
      before :each do
        # no specific actions for this case! yay!
      end

      it "is valid (because default value jumps in)" do
        @operation.should be_valid_for_committing
      end

      it "has default value set" do
        # this is more of a sanity check since
        # this sort of functionality clearly needs to be
        # tested in
        @operation.committer_name.should == "Just another Ruby hacker"
      end
    end
  end
end