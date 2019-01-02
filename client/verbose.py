# VERBOSE

def login_ver():
	username, password = input('Username: '), input('Password: ')
	return username, password

def book_ver():
	title, author, isbn, subject, location, cover = input('Title: '), input('Author: '), input('ISBN: '), input('Subject: '), input('Location: '), input('Cover URL: ')
	return title, author, isbn, subject, location, cover

login_ver()