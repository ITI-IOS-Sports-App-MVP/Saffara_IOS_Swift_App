require 'xcodeproj'

project_path = 'sports_app.xcodeproj'
project = Xcodeproj::Project.open(project_path)
test_target = project.targets.find { |t| t.name == 'sports_appTests' }

# Create groups if they don't exist
tests_group = project.main_group.find_subpath(File.join('sports_appTests'), true)
mocks_group = tests_group.find_subpath('Mocks', true)
data_group = tests_group.find_subpath('Data', true)
presenters_group = tests_group.find_subpath('Presenters', true)

# Add files to project and target
def add_file(project, group, target, path)
  file_ref = group.new_reference(path)
  target.add_file_references([file_ref])
end

add_file(project, mocks_group, test_target, 'Mocks/CoreDataMocks.swift')
add_file(project, mocks_group, test_target, 'Mocks/NetworkMocks.swift')
add_file(project, mocks_group, test_target, 'Mocks/ViewMocks.swift')
add_file(project, mocks_group, test_target, 'Mocks/UseCaseMocks.swift')

add_file(project, data_group, test_target, 'Data/CoreDataManagerTests.swift')
add_file(project, data_group, test_target, 'Data/RepositoryTests.swift')
add_file(project, data_group, test_target, 'Data/NetworkServiceTests.swift')

add_file(project, presenters_group, test_target, 'Presenters/HomePresenterTests.swift')
add_file(project, presenters_group, test_target, 'Presenters/FavoritesPresenterTests.swift')
add_file(project, presenters_group, test_target, 'Presenters/LeaguesPresenterTests.swift')
add_file(project, presenters_group, test_target, 'Presenters/LeagueDetailsPresenterTests.swift')
add_file(project, presenters_group, test_target, 'Presenters/TeamDetailsPresenterTests.swift')

project.save
puts "Files added successfully to the test target!"
