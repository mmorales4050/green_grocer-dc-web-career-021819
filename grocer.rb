def consolidate_cart(cart)
  reformatted_hash = {}
  list_of_groceries = []
  cart.each do |hash|
    reformatted_hash.merge!(hash.keys[0] => hash.values[0])
    list_of_groceries << hash.keys[0]
    reformatted_hash.each do |key, value|
      value.merge!(count: 0)
    end
  end
  list_of_groceries.each do |grocery|
    reformatted_hash.each do |key, value|
      if grocery == key
        reformatted_hash[key][:count] += 1
      end
    end
  end
  return reformatted_hash
end

def apply_coupons(cart, coupons)
  coupon_hash = {}
  coupons.each do |hash|
    cart.each do |key, value|
      if hash[:item] == key
        while hash[:num] <= value[:count]
          if coupon_hash.has_key?("#{hash[:item]} W/COUPON")
            coupon_hash["#{hash[:item]} W/COUPON"][:count] += 1
            value[:count] -= hash[:num]
          else
            coupon_hash.merge!("#{hash[:item]} W/COUPON" => {:price => hash[:cost], :clearance => value[:clearance], :count => 0})
            value[:count] -= hash[:num]
            coupon_hash["#{hash[:item]} W/COUPON"][:count] += 1
          end
        end
      end
    end
  end

  coupon_hash.each do |key, value|
    cart.merge!(key => value)
  end

  return cart
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance] == true
      value[:price] = (value[:price] * 0.8).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total_cost = 0.0
  cart.each do |key, value|
    total_cost += (value[:price] * value[:count])
  end
  if total_cost > 100.0
    total_cost = total_cost * 0.9
  end
  total_cost
end
