# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
#Engines::Testing.set_fixture_path

# Should redefine fixture directory to use plugin specific fixtures of
# inheritated classes.
Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + '/fixtures'
