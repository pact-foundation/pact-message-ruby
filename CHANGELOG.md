<a name="v0.6.0"></a>
### v0.6.0 (2020-02-10)


#### Features

* Add metadata to a message request	 ([796590f](/../../commit/796590f))
* support the _id attribute from the Pact Broker, and give each message an index	 ([3a05501](/../../commit/3a05501))


#### Bug Fixes

* add back support for using providerState instead of providerStates when updating a pact	 ([b494a76](/../../commit/b494a76))


<a name="v0.5.0"></a>
### v0.5.0 (2018-10-04)


#### Features

* **pact specification v3**
  * add support for multiple provider states and params	 ([b2c1cc7](/../../commit/b2c1cc7))


<a name="v0.4.5"></a>
### v0.4.5 (2018-07-07)


#### Bug Fixes

* include metaData in message pact	 ([e68ca4f](/../../commit/e68ca4f))


<a name="v0.4.3"></a>
### v0.4.3 (2018-05-06)


#### Features

* **version**
  * add version command to CLI, fixes #10	 ([f928248](/../../commit/f928248))


#### Bug Fixes

* **content**
  * rename message content -> contents. fixes #9	 ([0908962](/../../commit/0908962))


<a name="v0.4.1"></a>
### v0.4.1 (2018-04-05)


#### Features

* read/write metaData from/to v3 pact files	 ([7dfcbb9](/../../commit/7dfcbb9))


#### Bug Fixes

* locate content matching rules from correct path	 ([5254c01](/../../commit/5254c01))


<a name="v0.4.0"></a>
### v0.4.0 (2018-04-03)


#### Features

* add *partial* support for reading/writing array of provider states as specified in v3 spec	 ([e9ec6c3](/../../commit/e9ec6c3))


<a name="v0.3.0"></a>
### v0.3.0 (2018-04-03)


#### Features

* add pact-message reify to cli	 ([782a09b](/../../commit/782a09b))


<a name="v0.1.5"></a>
### v0.1.5 (2018-03-26)


#### Features

* upgrade to pact-support 1.5	 ([20fea42](/../../commit/20fea42))
* move pact message classes out of pact-support into pact-message	 ([a187c4a](/../../commit/a187c4a))
* update DSL syntax	 ([8766965](/../../commit/8766965))
* add cli for other languages to use	 ([b111edd](/../../commit/b111edd))
* reuse consumer contract writer from pact-mock_service	 ([93aa122](/../../commit/93aa122))
* create dsl and basic pact file writer	 ([5333564](/../../commit/5333564))


#### Bug Fixes

* set pact_specification_version in cli	 ([834d671](/../../commit/834d671))
* requires	 ([886068c](/../../commit/886068c))
* change executables path from exe to bin	 ([921a1c3](/../../commit/921a1c3))


