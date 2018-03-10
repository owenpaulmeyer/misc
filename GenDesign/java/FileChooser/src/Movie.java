
import gds.resources.Child;
import gds.resources.Design;
import gds.resources.Source;
import com.google.gson.Gson;
import gds.resources.GDS;
import gds.resources.Generate;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author owenpaulmeyer
 */
public class Movie {
    Design design = new Design();
    Gson gson = new Gson();
    Generate genit = new Generate();
    
    public void setSource(){
        BufferedReader read = null;
        String input=null;
        try{
		read = new BufferedReader(new FileReader("C:\\Users\\owenpaulmeyer\\Documents\\GDS\\roofSet.gds"));
                try {
                    input = read.readLine();
                } catch (IOException ex) {
                    Logger.getLogger(GDS.class.getName()).log(Level.SEVERE, null, ex);
                }
            }catch(FileNotFoundException fnf){System.out.println(fnf+": fileLoad trouble");}
        Child son = gson.fromJson(input, Child.class).clone();
        genit.setSource(son);
    }
    
    
    public static void main(String args[]) {
        Movie movie = new Movie();
        System.out.println("o hell o");
        movie.setSource();
        System.out.println("count: "+Child.flattenConnections(movie.genit.source().element()).size());
    }
}
