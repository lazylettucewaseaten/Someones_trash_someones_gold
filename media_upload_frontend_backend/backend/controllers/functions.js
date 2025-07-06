const express=require('express')
const mongoose=require('mongoose')
const fs = require('fs');
const path = require('path');
const {mediafiles}=require('../models/schema')
const multer=require('multer')
const crypto = require('crypto');
const secretKey = crypto.randomBytes(32); 
const iv = crypto.randomBytes(16); 
const uploadfiles=async (req,res) => {
    try {

        const File={
            name:req.body.name,
            data:req.file.buffer,
            mimetype:req.file.mimetype,
            
        }
        // console.log(File)
        await mediafiles.create(File)
        res.status(200).json({message:"success"})
    } catch (error) {
        res.status(500).json(error)
    }    
}
const getfiles =async (req,res) => {
    try {
        const allfiles=await mediafiles.find({})
        if(!allfiles){
            return res.status(404).json({message:"No files  to ftech"})
        }
        const filesdata=allfiles.map((file)=>({
            name:file.name,
            mimetype:file.mimetype,
            data:file.data.toString('base64')
        }))
        res.status(200).json(filesdata);
    } catch (error) {
        res.status(500).json(error)
    }
}
module.exports={uploadfiles,getfiles}