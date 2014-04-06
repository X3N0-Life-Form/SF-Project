# -*- coding: utf-8 -*-
# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.
Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.date_of_birth         "06/01/1990"
  user.weight                65
  user.ideal_weight          60
  user.height                1.80
  user.do_sport              false
  user.would_do_sport        true
end
