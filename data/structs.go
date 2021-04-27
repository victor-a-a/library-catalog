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

type UserData struck {
  FirstName     string
  LastName      string
  UserName      string
  ID            string
  Role          int
}

type PageData struct {
  User          UserData
  Books         []BookData
}
