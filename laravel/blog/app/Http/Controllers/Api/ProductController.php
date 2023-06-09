<?php

namespace App\Http\Controllers\Api;

use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\Controller;
use App\Models\Product;

class ProductController extends Controller
{
    public function index()
    {
        $data = Product::get();
        return $this->successResponse($data);
    }


    public function store()
    {
        $rules =  [
            'name' => 'required',
            'category' => 'required',
            'quantity'   => 'required',
        ];
        $validator = Validator::make(request()->all(), $rules);
        $errors = $this->formatErrors($validator->errors());
        if($validator->fails()) {return $this->errorResponse($errors);}

        $data = Product::create(request()->all());
        $message = "Created Successfully.";
        return $this->successResponse($data, $message);
    }
}
