<?php

namespace App\Http\Controllers;

use App\Calculator;
use Illuminate\Http\Request;

class CalcController extends Controller
{
    public function save(Request $request)
    {
        $calculation = Calculator::create([
            'name' => $request->input('name'),
            'age' => $request->input('age'),
            'retirement_age' => $request->input('retirementAge'),
            'annual_income' => $request->input('annualIncome'),
            'needed_income_percent' => $request->input('neededIncomePercent'),
            'annual_savings_percent' => $request->input('annualSavingsPercent'),
            'annual_return_percent' => $request->input('annualReturnPercent'),
        ]);
        if ($calculation) {
            return ['message' => 'The data is saved.'];
        }
        return ['message' => 'Error happened.'];
    }
}
