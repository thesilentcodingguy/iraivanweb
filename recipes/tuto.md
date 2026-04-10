rails g scaffold User name:string email:string
rails g scaffold Recipe title:string ingredients:text user:references
rails g scaffold Comment title:string user:references recipe:references
