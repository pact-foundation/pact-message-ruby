bundle exec bin/pact-message update '{
  "description": "a test mesage",
  "content": {
    "name": {
      "contents": "Mary",
      "json_class": "Pact::SomethingLike"
    }
  }
}
' --consumer Foo --provider Bar --pact-dir ./tmp --pact-specification-version 3.0.0