package data

const API_KEY = "AIzaSyBBlxBSRVl8sK4crq2x5qRCFbLfXxj1CK0"

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
  CopyNum       int
  Owner         string
  Location      string
  Status        string
  Condition     string
}
