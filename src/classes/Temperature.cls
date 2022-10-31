/**
 * Created by ADMIN on 30.10.2022.
 */

public with sharing class Temperature {

    public String metric;
    public Integer temp;

    public Temperature(String metric, Integer temp){
        this.metric = metric;
        this.temp = temp;
    }
    public Temperature(){}


}