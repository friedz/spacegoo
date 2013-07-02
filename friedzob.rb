#!/usr/bin/ruby
# encoding: UTF-8
#
#Sollte sich auf den Server verbinden und dann spielen
#

require 'socket'
require 'json'

username = "friedzob"
password = "coreckthorsbatterystaple"

puts "Versuche Verbindung zu öffnen"
s = TCPSocket.new '172.22.37.15', 6000

def myId(json)
  json["players"].each do |p|
    if p["itsme"] then
      return p["id"]
    end
  end
end

def strongOwnPlanet(json, me)
  id = 0
  power = 0
  json["planets"].each do |p|
    strength = 0
    if p["owner_id"] == me then
      p["ships"].each do |s|
        strength += s
      end
    end
    if power < strength then
      power = strength
      id = p["id"]
    end
  end
  return id
end

def cordinate(json, id)
  json["planets"].each do |p|
    if p["id"] == id then
      return {"x" => p["x"], "y" => p["y"]}
    end
  end
end

def nearEnemyPlanet(json, me, cordinate)
  id = 0
  dist = 100000
  json["planets"].each do |p|
    if p["owner_id"] != me then
      abst = (p["x"] - cordinate["x"])**2 + (p["y"] - cordinate["y"])**2
      if dist > abst then
        dist = abst
        id = p["id"]
      end
    end
  end
  return id
end

def allA(json, id)
  json["planets"].each do |p|
    if p["id"] == id then
      return p["ships"][0]
    end
  end
end

def allB(json, id)
  json["planets"].each do |p|
    if p["id"] == id then
      return p["ships"][1]
    end
  end
end

def allC(json, id)
  json["planets"].each do |p|
    if p["id"] == id then
      return p["ships"][2]
    end
  end
end

def myPlanetCount(json, me)
  count = 0
  json["planets"].each do |p|
    if(p["owner_id"] == me)
      count += 1
    end
  end
  return count
end

def totalPlanetCount(json)
  count = 0
  json["planets"].each do |p|
    count += 1
  end
  return count
end


puts "Hat wohl geklappt"

line = s.gets
puts line

s.puts("login #{username} #{password}")
puts "Authentication successful"


while line = s.gets
  puts "..."
  #puts line
  if line[0] == "{" then
    json = JSON.parse(line)
    #puts json
    #puts "\n"
    me = myId(json)
    from = strongOwnPlanet(json, me)
    fromCord = cordinate(json, from)
    to = nearEnemyPlanet(json, me, fromCord)
    a = allA(json, from)
    b = allB(json, from)
    c = allC(json, from)
    n = myPlanetCount(json, me)
    m = totalPlanetCount(json)
    puts "Your Player #{me},"
    puts "And you control #{n} of #{m} Planets"
    puts "send #{from} #{to} #{a} #{b} #{c}"
    puts "So you send from (#{fromCord["x"]}, #{fromCord["y"]})"
    s.puts "send #{from} #{to} #{a} #{b} #{c}"
  else
    puts line
  end
end

s.close


