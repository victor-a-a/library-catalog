package data

import (
  . "victoraa/virtual-bookshelf/auth"
  "encoding/json"
  "net/http"
  "io/ioutil"
  "errors"
)

// LOCAL STRUCTS FOR PARSING JSON //
type Identifiers struct {
  Type        string               `json:"type"`
  Identifier    string             `json:"identifier"`
}

type ImageLink struct {
  Cover         string            `json:"thumbnail"`
}

type VolumeInfo struct {
  Title         string            `json:"title"`
  Authors       []string          `json:"authors"`
  Publisher     string            `json:"publisher"`
  PublishDate   string            `json:"publishedDate"`
  Identifiers   []Identifiers     `json:"industryIdentifiers"`
  Category      []string          `json:"categories"`
  ImageLink     ImageLink         `json:"imageLinks"`
  Language      string            `json:"language"`
}

type Item struct {
  VolumeInfo    VolumeInfo        `json:"volumeInfo"`
}

type Jsonstruct struct {
  TotalItems    int               `json:"totalItems"`
  Items         []Item            `json:"items"`
}

// FUNCTIONS //
func GetBookData(isbn string) (*BookData, error) {
  // Get json data
  resp, err := http.Get("https://www.googleapis.com/books/v1/volumes?q=isbn:" + isbn + "&key=" + API_KEY)
  if err != nil {
    return nil, err
  }
  defer resp.Body.Close()

  // Convert json to byte array
  bytes, err := ioutil.ReadAll(resp.Body)
  if err != nil {
    return nil, err
  }

  // Reading json
  var temp Jsonstruct
  err = json.Unmarshal(bytes, &temp)
  if err != nil {
    return nil, err
  }

  // Loading data into struct
  if temp.TotalItems == 0 {
    return nil, errors.New("ISBN not in records")
  }

  data := BookData{
    Title: temp.Items[0].VolumeInfo.Title,
    Authors: temp.Items[0].VolumeInfo.Authors,
    Publisher: temp.Items[0].VolumeInfo.Publisher,
    PublishDate: temp.Items[0].VolumeInfo.PublishDate,
    Cover: temp.Items[0].VolumeInfo.ImageLink.Cover,
    Category: temp.Items[0].VolumeInfo.Category,
    Language: temp.Items[0].VolumeInfo.Language,
  }
  if len(isbn) == 13 {
    data.ISBN13 = isbn
  } else if len(isbn) == 10 {
    data.ISBN10 = isbn
  }
  for _, j := range temp.Items[0].VolumeInfo.Identifiers {
    if j.Type == "ISBN_10" {
      data.ISBN10 = j.Identifier
    } else if j.Type == "ISBN_13" {
      data.ISBN13 = j.Identifier
    }
  }

  return &data, nil
}
