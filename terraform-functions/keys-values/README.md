## Working with key and value in Maps:
- In Terraform, you often need to work with keys and values from maps. 
- Although there's no direct key or value function, you can use the keys() and values() functions to extract all keys or values from a map, respectively.

## 1. keys Function:
- The keys function retrieves all keys from a given map as a list.

## Syntax:
- `keys(map)`
- `map`: The map from which you want to extract keys.

## 2. values Function:
- The values function retrieves all values from a given map as a list.

## Syntax:
- `values(map)`
- `map`: The map from which you want to extract values.