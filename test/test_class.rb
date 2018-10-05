class FooController
  def bad(thing)
    thing[:stuff].each { |stuff_key|
      ActiveRecordClass.destroy(stuff_key)
    }
  end

  def good 
    ActiveRecordClass.destroy(stuff_key)
    
    10.times { ActiveRecordClass.destroy }
  end
end
