class Testcase < ActiveRecord::Base
	include Redmine::SafeAttributes
	
    validates :name, 		presence: 	true,
							length:		{in:5..50},
							uniqueness: { scope: :path}
						
	validates :path,		presence:	true
							
	attr_accessible :name, :description, :time_last_run, 
					:path, :status, :test_type
					
	has_many :issues, through: :testcaseissuerelations
end
