import Foundation

public class Array2D<T: Equatable> {
    
    var cols:Int, rows:Int
    public var matrix:[T]
    
    public init(cols:Int, rows:Int, _ defaultValue:T){
        self.cols = cols
        self.rows = rows
        matrix = Array(count:cols*rows,repeatedValue:defaultValue)
    }
    
    public  init(cols:Int, rows:Int, _ elements : [T]) {
        self.cols = cols
        self.rows = rows
        self.matrix = Array(elements)
    }
    
    public subscript(col:Int, row:Int) -> T {
        get{
            return matrix[cols * row + col]
        }
        set{
            matrix[cols * row + col] = newValue
        }
    }
    
    public func colCount() -> Int {
        return self.cols
    }
    
    public func rowCount() -> Int {
        return self.rows
    }
    
    public func withinBounds(x: Int, y: Int) -> Bool {
        return x >= 0 && x < cols && y >= 0 && y < rows
    }
    
    public func contains(element: T) -> Bool {
        return matrix.indexOf(element) != nil
    }
    
    public func indexOf(element: T) -> (col: Int, row: Int)? {
        for x in 0..<cols {
            for y in 0..<rows {
                if self[x, y] == element {
                    return (x, y)
                }
            }
        }
        return nil
    }
    
    public var description: String {
        var result = ""
        for y in 0..<rows {
            for x in 0..<cols {
                result += "\(self[x, y]) "
            }
            result += "\n"
        }
        return result
    }
}