# EHPT

## Description
Employement Hero Pivotal Tracker: A simple command line tool to import stories to Pivotal Tracker via CSV file.

## Installation
```
  $ gem install ehpt
```


## Usage
#### Command
```
  $ ehpt <path_to/stories.csv> <API_TOKEN> <PROJECT_ID>
```
That's it. Enjoy.
#### CSV structure
This is the sample [csv file](https://docs.google.com/spreadsheets/d/1ew69plL2-jOF3oJb0RNRAmyRQfer8VvQfR8DGwD6_Ro/edit?usp=sharing). For more information about the story attributes, please visit Pivotal Tracker [API Documentation](https://www.pivotaltracker.com/help/api/rest/v5#projects_project_id_stories_post)
#### API Token
Navigate to https://www.pivotaltracker.com/profile and scroll down, you should see your API TOKEN there. If you don't already have it, create one.

If you don't specify the `requested_by_id` in your csv file, the user with this API TOKEN will be the requester of the stories.
#### Project Id
Navigate to your project dashboard. The last digits in the url is the project's id. The url should be something like `https://www.pivotaltracker.com/n/projects/1234567`

## Thank you
Special thanks to @phthhieu for his initial script and his encouragement.

## License
MIT
