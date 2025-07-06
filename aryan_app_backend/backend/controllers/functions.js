const express=require('express')
const mongoose=require('mongoose')
const {UserLogin,Merchant,UserWarranty ,ContactUs, AnimalData}=require('../models/schema')
const asyncWrapper =require('../middleware/async')
const nodemailer =require("nodemailer")
require('dotenv').config();
const jwt =require('jsonwebtoken')
const multer = require('multer');
const verifyToken =require('../middleware/auth')
const bcrypt =require('bcrypt');
const saltRounds=10
salt=bcrypt.genSaltSync(saltRounds)



function getIndianSeason(date = new Date()) {
    const month = date.getMonth() + 1; 
    if (month >= 3 && month <= 5) {
        return "Summer"; 
    } else if (month >= 6 && month <= 9) {
        return "Rainy"; 
    } else if (month >= 10 && month <= 11) {
        return "Autumn"; 
    } else {
        return "Winter"; 
    }
}


    const addingnewuser=async (req,res) => {
    let unhashedpassword=(req.body.password)
    hashed=bcrypt.hashSync(unhashedpassword,salt)
    try{
        const userinfo={
            "username":req.body.username,
            "email":req.body.email,
            "password":hashed
        }
        const task=await UserLogin.create(userinfo)

        res.status(200).json({"success":true});
    }
    catch(error){
        res.status(500).json(error)
    }
    }


    const userverification=async(req,res)=>{
        const {email,password}=req.body;
        try {
            const user=await UserLogin.find({email});
            if(bcrypt.compare(password,user[0].password)){
                res.status(200).json({"success":true});
            }
            else{
                res.status(400).json({"success":false,"message":"Credentials are wrong"});
            }
        } catch (error) {
            console.log(error)
        }
    }   


    const animalinfoaddupdate=async(req,res)=>{
        
        const {blood_pressure,temperature,strava,lactation_level,owner}=req.body;
        try {
            
                const animalinfo={
                    "blood_pressure":blood_pressure,
                    "temperature":temperature,
                    "strava":strava,
                    "lactation_level":lactation_level,
                    "season":getIndianSeason(new Date()),
                    "owner":owner,
                }
                const task=await AnimalData.create(animalinfo);
                res.status(200).json({"success":true});            
            
        } catch (error) {
            console.log(error)
        }
        //write for updating this 
        //write for getting email after auth
    }
    const findanimalinfo=async(req,res)=>{
        const {email}=req.body;
        try{

            const animalinfo=await AnimalData.find({owner:email})
            // console.log(animalinfo)
            res.status(200).json({"success":true,"message":animalinfo});
        }
        catch(error){
            console.log(error)
        }
    }


const Contact =asyncWrapper(async(req ,res)=>{
    // console.log("hello")
    const task = await ContactUs.create(req.body)
    const mailData = {
        from:process.env.Email ,  // sender address
        to: req.body.email,    // list of receivers
        subject: 'Conformation of the Query',
        text: 'Your Query Has been Received ,We will process it shortly ',
        html: '<b>Hey there! </b><br> This is our first message sent with Nodemailer<br/>',
    };
    
    // Create transporter using Gmail's SMTP server
    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 465,  // Correct SMTP port for Gmail (SSL)
        secure: true,  // Use SSL
        auth: {
            user: process.env.Email,  // Your Gmail address
            pass: process.env.Password,         // Your Gmail app password (not your account password)
        },
    });
    transporter.sendMail(mailData, (error, info) => {
        if (error) {
            console.log('Error sending email:', error);
        } else {
            console.log('Email sent: ' + info.response);
        }
    });
    res.status(201).json({task});
});

// Adding Forget Password apis

const OTP =asyncWrapper(async(req ,res)=>{
    // console.log(req.body)
    const mailData = {
        from:process.env.Email ,  // sender address
        to: req.body.email,    // list of receivers
        subject: 'Conformation of the Query',
        text: 'Your Query Has been Received ,We will process it shortly ',
        html: `<b>Hey there! </b><br> Your OTP for Warranty Storage Password Change is ${req.body.num}<br/>`,
    };
    
    // Create transporter using Gmail's SMTP server
    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 465,  // Correct SMTP port for Gmail (SSL)
        secure: true,  // Use SSL
        auth: {
            user: process.env.Email,  // Your Gmail address
            pass: process.env.Password,         // Your Gmail app password (not your account password)
        },
    });
    transporter.sendMail(mailData, (error, info) => {
        if (error) {
            console.log('Error sending email:', error);
        } 
    });
    // res.status(201).json({task});
});


const UpdatePassword=async (req,res) => {
    const {email ,password} =req.body
    let unhashedpassword=(password)
    const saltRounds=10
    salt=bcrypt.genSaltSync(saltRounds)
    const hashed=bcrypt.hashSync(unhashedpassword,salt)
    try{
        const task=await UserLogin.findOneAndUpdate({email} ,{password:hashed})
        // console.log(hashed)
        res.status(201).json({task});

    }
    catch(error){
        res.status(500).json(error)
    }
}

module.exports={addingnewuser,Contact,OTP ,UpdatePassword,userverification,findanimalinfo ,animalinfoaddupdate}
