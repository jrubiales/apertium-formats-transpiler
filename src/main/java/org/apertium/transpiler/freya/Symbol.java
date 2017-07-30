
package org.apertium.transpiler.freya;

import java.util.List;
import java.util.Objects;

/**
 *
 * @author juanfran
 */
public class Symbol {
    
    private String id;
    
    private int type;
    
    public Symbol(String id) {
        this.id = id;
        this.type = 0;
    }
    
    public Symbol(String id, int type) {
        this.id = id;
        this.type = type;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 29 * hash + Objects.hashCode(this.id);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Symbol other = (Symbol) obj;
        if (!Objects.equals(this.id, other.id)) {
            return false;
        }
        return true;
    }
    
    public Symbol search(List<Symbol> symbols){
        Symbol s = null;
        boolean found = false;
        int n = symbols.size();
        for(int i = 0; i < n && !found; ++i){
            if(symbols.get(i).id.equals(id)){
                s = symbols.get(i);
                found = true;
            }
        }
        return s;
    }
        
    
}