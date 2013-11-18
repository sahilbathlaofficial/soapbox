# CR_Priyank: Description for every rake task is must
#[Fixed] - Added appropriate Description
namespace :users do
  desc "Make admin for this application"
  task :make_admin => :environment do
    puts "Input email for admin"
    email = STDIN.gets.chomp
    user = User.find_by(email: email)
    if !(user.nil?)
      user.is_admin = true 
      user.save!
    end
  end    
end