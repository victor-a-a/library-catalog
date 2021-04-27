package data

type BookData struct {
  Title         string
  Authors       []string
  Publisher     string
  PublishDate   string
  ISBN10        string
  ISBN13        string
  Cover         string
  Category      []string
  Language      string
  Format        string
  ID            string
  Owner         string
  Location      string
  Status        int
  Condition     int
  Privacy       int
}

type PageData struct {
  FirstName     string
  LastName      string
  ID            string
  Books         []BookData
}
