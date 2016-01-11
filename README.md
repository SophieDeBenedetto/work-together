# WorkTogether

Generates groups of four or two based on similar progress, different progress or randomly. Call the gem from the command line with the follow commands, and give it the batch id number of your class. For example, Web-1115 is batch 168:

`work-together pairs --random 168`

Gem sends request to Learn API endpoint of a given batch, parses payload into csv, uses csv to generate collection of Student objects and groups those students according to specification. 

## Available Commands

`gem install work_together`

`work-together --help`

`work-together pairs --random batch-number`

`work-together tables --random batch-number`

`work-together pairs --mindful batch-number`

`work-together talbes --mindful batch-number`

`work-together pairs --progress batch-number`

`work-together tables --progress batch-number`

## Using the gem in another project

Public-facing class is `WorkTogether` class. 

* Initialize with an argument of the batch id number `WorkTogether.new(batch-id)`. 
* Generate groups from CSV with the `#generate_togetherness` method. This method takes in two arguments:

```ruby
 wt = WorkTogether.new(168)
 wt.generate_togetherness(["pairs", "--random"], "quiet")`
```

* First argument of `#generate_togetherness` is an array that contains the following options: first element-`"pairs", "random", "mindful"`, second element -`"--random", "--mindful", "--progress"`. 
* Third argument is optional, defaults to `nil`. Use `"quiet"` if you *don't* wan't to `puts` out resulting groups to the terminal. 
* To generate a batch, i.e. a collection of Student objects, without then generating groups, use the `#make_batch` method:

```ruby
wt = WorkTogether.new(168)
wt.make_batch
=> [#<Student:0x007fbd6b4341c8
  @active_track="Web Development Immersive 2016",
  @completion="201",
  @email="asialindsay@gmail.com",
  @first_name="Asia",
  @github_username="asialindsay",
  @last_name="Lindsay">,
 #<Student:0x007fbd6b42fd58
  @active_track="Web Development Immersive 2016",
  @completion="201",
  @email="cmcguigan33@gmail.com",
  @first_name="Chris",
  @github_username="cmc33",
  @last_name="McGuigan">,
  ...]
```

* Currently, Students have first and last names, active track (i.e. batch), completion (number of labs and readings they have finished), email and Github username. 