<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class CalcResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param \Illuminate\Http\Request $request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'age' => $this->age,
            'retirementAge' => $this->retirement_age,
            'annualIncome' => $this->annual_income,
            'neededIncomePercent' => $this->needed_income_percent,
            'annualSavingsPercent' => $this->annual_savings_percent,
            'annualReturnPercent' => $this->annual_return_percent
        ];
    }
}
