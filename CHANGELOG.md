# Changelog

# main

* Update rubocop dependencies and fix warnings ([#85](https://github.com/petalmd/rubocop-petal/pull/85))

# v1.5.0 (2024-12-11)

* Add Sidekiq/PerformInline ([#82](https://github.com/petalmd/rubocop-petal/pull/82))
* Add Chewy/UpdateIndexArgument ([#83](https://github.com/petalmd/rubocop-petal/pull/83))

# v1.4.0 (2024-06-14)

* Set `Rails/Date`, `AllowToTime` config to false. ([#80](https://github.com/petalmd/rubocop-petal/pull/80))
* Remove cop `RSpec/AuthenticatedAs`. ([#79](https://github.com/petalmd/rubocop-petal/pull/79))
* Add new cops for Sidekiq. ([#77](https://github.com/petalmd/rubocop-petal/pull/77))

# v1.3.1 (2024-02-13)

* Remove usage of `delegate` from activesupport. ([#78](https://github.com/petalmd/rubocop-petal/pull/78)) 

# v1.3.0 (2024-01-09)

* Added autocorrection for `RSpec/MultipleExpectations`. 
 (Fix [#59](https://github.com/petalmd/rubocop-petal/issues/59)). ([#74](https://github.com/petalmd/rubocop-petal/pull/74))
* Update rubocop dependencies and minimum Ruby version. (Fix [#68](https://github.com/petalmd/rubocop-petal/issues/68)). ([#75](https://github.com/petalmd/rubocop-petal/pull/75))
* Enabled `RSpec/MultipleExpectations`. ([#73](https://github.com/petalmd/rubocop-petal/pull/73))
* Added new cops from test-prod RSpec/AggregateExamples. ([#72](https://github.com/petalmd/rubocop-petal/pull/72))

# v1.2.0 (2023-09-28)

* Added cop `Rails/DestroyAllBang`(Fix [#42](https://github.com/petalmd/rubocop-petal/issues/42)). ([#65](https://github.com/petalmd/rubocop-petal/pull/65))
* Added cop `Chewy/FieldType`. ([#64](https://github.com/petalmd/rubocop-petal/pull/64))
* Fix `Migration/ChangeTableReferences` offense location (Fix [#61](https://github.com/petalmd/rubocop-petal/issues/61)) ([#62](https://github.com/petalmd/rubocop-petal/pull/62))
* Added cop `Sidekiq/NoEarlyNilReturn` ([#58](https://github.com/petalmd/rubocop-petal/pull/58))
* Added cop `Rails/EnumStartingValue` ([#57](https://github.com/petalmd/rubocop-petal/pull/57))
* Added cop `Migration/StandaloneAddReference` ([#54](https://github.com/petalmd/rubocop-petal/pull/54))
* Update `Migration/ChangeTableReferences` on send alias and message to handle removing references. ([#55](https://github.com/petalmd/rubocop-petal/pull/55))

# v1.1.2 (2023-05-30)

* Fix `Migration/ChangeTableReferences` with multiple nested blocks. ([#51](https://github.com/petalmd/rubocop-petal/pull/51))

# v1.1.1 (2023-05-29)

* Relax rubocop dependencies. ([#50](https://github.com/petalmd/rubocop-petal/pull/50))

# v1.1.0 (2023-05-24)

* Remove cop `Rails/TableName` in favor of [Rails/TableNameAssignment](https://docs.rubocop.org/rubocop-rails/cops_rails.html#railstablenameassignment)
  and enable it in base config (Fix [#45](https://github.com/petalmd/rubocop-petal/issues/45)). ([#48](https://github.com/petalmd/rubocop-petal/pull/48))
* Adjust `Metrics` base config. ([#49](https://github.com/petalmd/rubocop-petal/pull/49))
* Added cop `Migration/ChangeTableReferences` ([#47](https://github.com/petalmd/rubocop-petal/pull/47))
* Added cop `Migration/AlwaysBulkChangeTable` ([#46](https://github.com/petalmd/rubocop-petal/pull/46))

# v1.0.0 (2023-05-15)

* Unified cops to be reused by others projects. ([#41](https://github.com/petalmd/rubocop-petal/pull/41))

# v0.9.0 (2023-05-12)

* Remove RSpec/JsonParseResponseBody duplicated cop (Fix [#39](https://github.com/petalmd/rubocop-petal/issues/39)). ([#44](https://github.com/petalmd/rubocop-petal/pull/44))
* Update RSpec/SidekiqInline example and message (Fix [#35](https://github.com/petalmd/rubocop-petal/issues/35)). ([#43](https://github.com/petalmd/rubocop-petal/pull/43))

# v0.8.0 (2023-02-21)

* Added cop `Performance/Snif` ([#31](https://github.com/petalmd/rubocop-petal/pull/31))
* Updated gemspec file. ([#30](https://github.com/petalmd/rubocop-petal/pull/30))
* Added cop `RSpec/JsonParseResponseBody and RSpec/JsonResponse` ([#27](https://github.com/petalmd/rubocop-petal/pull/27))

# v0.7.0

* Support more cases for `Grape/UnnecessaryNamespace`. ([#26](https://github.com/petalmd/rubocop-petal/pull/26))

# v0.6.0

* Added cop `RSpec/SidekiqInline` ([#24](https://github.com/petalmd/rubocop-petal/pull/24))
* Remove cop `Rails/ValidateUniquenessCase` ([#21](https://github.com/petalmd/rubocop-petal/pull/21))

# v0.5.0

* Added cop `Rails/ValidateUniquenessCase` ([#20](https://github.com/petalmd/rubocop-petal/pull/20))

# v0.4.1

* Fix typo default config SafeAutoCorrect RSpec/StubProducts ([#19](https://github.com/petalmd/rubocop-petal/pull/19))

# v0.4.0

* Added cop `RSpec/StubProducts` ([#18](https://github.com/petalmd/rubocop-petal/pull/18))

# v0.3.1

* Correct cop name `Migration/SchemaStatementsMethods` in config ([#17](https://github.com/petalmd/rubocop-petal/pull/17))

# v0.3.0

* Added cop `Added Migration/ForeignKeyOption` ([#11](https://github.com/petalmd/rubocop-petal/pull/11))
* Added cop `Added Grape/PreferNamespace` ([#6](https://github.com/petalmd/rubocop-petal/pull/6))
* Added cop `Added Migration/SchemaStatementsMethods` ([#14](https://github.com/petalmd/rubocop-petal/pull/14))
* Remove cop `Added Migration/UseChangeTableBulk` ([#15](https://github.com/petalmd/rubocop-petal/pull/15))
* Update cop `Grape/PreferNamespace` ([#16](https://github.com/petalmd/rubocop-petal/pull/16))

# v0.2.1

* Update lock dependencies `rubocop-rails` ([#9](https://github.com/petalmd/rubocop-petal/pull/9))

# v0.2.0

* Added cop `RSpec/AuthenticatedAs` ([#3](https://github.com/petalmd/rubocop-petal/pull/3))
* Added cop `Grape/UnnecessaryNamespace` ([#2](https://github.com/petalmd/rubocop-petal/pull/2))
* Added cop `RSpec/CreateListMax` ([#4](https://github.com/petalmd/rubocop-petal/pull/4))
* Added Cop `Migration/UseChangeTableBulk` ([#7](https://github.com/petalmd/rubocop-petal/pull/7))
* Added cop `Grape/HelpersIncludeModule` ([#1](https://github.com/petalmd/rubocop-petal/pull/1))

# v0.1.0

* First version
