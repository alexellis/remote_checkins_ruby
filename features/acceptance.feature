#encoding: utf-8
Feature: Show that we can connect to the Redis repo

Scenario: Connect to running repo
 Given redis is available
 When I connect
 Then it does not error
 
  
Scenario: Produce error when we cannot connect to running repo
 Given redis is not available
 When I connect
 Then it gives us an error

 