# EHPT
[![Gem Version](https://badge.fury.io/rb/ehpt.svg)](https://badge.fury.io/rb/ehpt)
![Build](https://img.shields.io/circleci/build/github/phamhoaivu911/ehpt/master)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)
![Downloads](https://img.shields.io/gem/dtv/ehpt)

## Description
Employement Hero Pivotal Tracker: A simple command line tool to import stories to Pivotal Tracker via CSV file.

## Installation
```
  $ gem install ehpt
```


## Usage
### Command
```
  $ ehpt <path_to/stories.csv> <API_TOKEN> <PROJECT_ID>
```
That's it. Enjoy.
### CSV structure
This is the sample [csv file](https://docs.google.com/spreadsheets/d/1ew69plL2-jOF3oJb0RNRAmyRQfer8VvQfR8DGwD6_Ro/edit?usp=sharing). For more information about the story attributes, please visit Pivotal Tracker [API Documentation](https://www.pivotaltracker.com/help/api/rest/v5#projects_project_id_stories_post)

#### Note
- You can specify the requester of a story by using the initials. Instead of providing the `requested_by_id` attribute, you can provide the attribute `requested_by` with value is the initials of the user.
- Similar to `requested_by`, you can specify the owners of a story by using the initial. Instead of providing the `owner_ids` attribute, you can provide the attribute `owners` with value is the list of initials of the users.
- Initials is how your initials will appear to others in PT. Please visit [Pivotal Tracker](https://www.pivotaltracker.com/help/articles/updating_your_name_email_initials/) for more information.

### API Token
Navigate to https://www.pivotaltracker.com/profile and scroll down, you should see your API TOKEN there. If you don't already have it, create one.

If you don't specify the `requested_by_id` or `requested_by` in your csv file, the user with this API TOKEN will be the requester of the stories.
### Project Id
Navigate to your project dashboard. The last digits in the url is the project's id. The url should be something like `https://www.pivotaltracker.com/n/projects/1234567`

## Thank you
Special thanks to [@phthhieu](https://github.com/phthhieu) for his initial script and his encouragement.

## License
MIT

## Caveat
Pivotal tracker has its own CSV import/export feature. More information [here](https://www.pivotaltracker.com/help/articles/csv_import_export/)
