"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { Textarea } from "@/components/ui/textarea"
import { type SurveyQuestion } from "@/services/surveys_service"
import { DragDropContext, Droppable, Draggable } from "@hello-pangea/dnd"
import { GripVertical, Plus, Trash2, Type } from "lucide-react"
import { useState } from "react"
import { Badge } from "@/components/ui/badge"

interface SurveyBuilderProps {
    questions: SurveyQuestion[]
    onQuestionsChange: (questions: SurveyQuestion[]) => void
}

export default function SurveyBuilder({ questions, onQuestionsChange }: SurveyBuilderProps) {
    const [editingQuestion, setEditingQuestion] = useState<SurveyQuestion | null>(null)

    const addQuestion = (type: SurveyQuestion['type']) => {
        const newQuestion: SurveyQuestion = {
            id: Date.now().toString(),
            type,
            title: '',
            description: '',
            required: false,
            order: questions.length + 1,
            options: type === 'single_choice' || type === 'multi_choice' ? [''] : undefined,
            scale: type === 'scale' ? { min: 1, max: 5 } : undefined
        }
        onQuestionsChange([...questions, newQuestion])
        setEditingQuestion(newQuestion)
    }

    const updateQuestion = (id: string, updates: Partial<SurveyQuestion>) => {
        const updatedQuestions = questions.map(q => 
            q.id === id ? { ...q, ...updates } : q
        )
        onQuestionsChange(updatedQuestions)
    }

    const deleteQuestion = (id: string) => {
        const updatedQuestions = questions.filter(q => q.id !== id)
        // Reorder remaining questions
        const reorderedQuestions = updatedQuestions.map((q, index) => ({
            ...q,
            order: index + 1
        }))
        onQuestionsChange(reorderedQuestions)
        setEditingQuestion(null)
    }

    const handleDragEnd = (result: any) => {
        if (!result.destination) return

        const items = Array.from(questions)
        const [reorderedItem] = items.splice(result.source.index, 1)
        items.splice(result.destination.index, 0, reorderedItem)

        // Update order numbers
        const reorderedQuestions = items.map((item, index) => ({
            ...item,
            order: index + 1
        }))

        onQuestionsChange(reorderedQuestions)
    }

    const addOption = (questionId: string) => {
        const question = questions.find(q => q.id === questionId)
        if (!question || !question.options) return

        const updatedOptions = [...question.options, '']
        updateQuestion(questionId, { options: updatedOptions })
    }

    const updateOption = (questionId: string, optionIndex: number, value: string) => {
        const question = questions.find(q => q.id === questionId)
        if (!question || !question.options) return

        const updatedOptions = [...question.options]
        updatedOptions[optionIndex] = value
        updateQuestion(questionId, { options: updatedOptions })
    }

    const removeOption = (questionId: string, optionIndex: number) => {
        const question = questions.find(q => q.id === questionId)
        if (!question || !question.options) return

        const updatedOptions = question.options.filter((_, index) => index !== optionIndex)
        updateQuestion(questionId, { options: updatedOptions })
    }

    const getQuestionTypeLabel = (type: string) => {
        switch (type) {
            case 'short_text': return 'Short Text'
            case 'long_text': return 'Long Text'
            case 'single_choice': return 'Single Choice'
            case 'multi_choice': return 'Multiple Choice'
            case 'scale': return 'Scale'
            case 'date': return 'Date'
            case 'yes_no': return 'Yes/No'
            default: return type
        }
    }

    const renderQuestionEditor = (question: SurveyQuestion) => {
        return (
            <Card className="mb-4">
                <CardHeader>
                    <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                            <Type className="h-4 w-4" />
                            <span className="text-sm font-medium">{getQuestionTypeLabel(question.type)}</span>
                        </div>
                        <Button
                            variant="ghost"
                            size="sm"
                            onClick={() => deleteQuestion(question.id)}
                        >
                            <Trash2 className="h-4 w-4" />
                        </Button>
                    </div>
                </CardHeader>
                <CardContent className="space-y-4">
                    <div className="space-y-2">
                        <Label>Question Title *</Label>
                        <Input
                            value={question.title}
                            onChange={(e) => updateQuestion(question.id, { title: e.target.value })}
                            placeholder="Enter your question"
                        />
                    </div>

                    <div className="space-y-2">
                        <Label>Description (Optional)</Label>
                        <Textarea
                            value={question.description || ''}
                            onChange={(e) => updateQuestion(question.id, { description: e.target.value })}
                            placeholder="Add description or help text"
                            rows={2}
                        />
                    </div>

                    <div className="flex items-center space-x-2">
                        <Switch
                            checked={question.required}
                            onCheckedChange={(checked) => updateQuestion(question.id, { required: checked })}
                        />
                        <Label>Required</Label>
                    </div>

                    {/* Question type specific options */}
                    {(question.type === 'single_choice' || question.type === 'multi_choice') && (
                        <div className="space-y-2">
                            <Label>Options</Label>
                            {question.options?.map((option, index) => (
                                <div key={index} className="flex gap-2">
                                    <Input
                                        value={option}
                                        onChange={(e) => updateOption(question.id, index, e.target.value)}
                                        placeholder={`Option ${index + 1}`}
                                    />
                                    <Button
                                        variant="ghost"
                                        size="sm"
                                        onClick={() => removeOption(question.id, index)}
                                        disabled={question.options!.length <= 1}
                                    >
                                        <Trash2 className="h-4 w-4" />
                                    </Button>
                                </div>
                            ))}
                            <Button
                                variant="outline"
                                size="sm"
                                onClick={() => addOption(question.id)}
                            >
                                <Plus className="h-4 w-4 mr-2" />
                                Add Option
                            </Button>
                        </div>
                    )}

                    {question.type === 'scale' && (
                        <div className="grid grid-cols-2 gap-4">
                            <div className="space-y-2">
                                <Label>Minimum Value</Label>
                                <Input
                                    type="number"
                                    value={question.scale?.min || 1}
                                    onChange={(e) => {
                                        const min = parseInt(e.target.value);
                                        const prev = question.scale || { min: 1, max: 5 };
                                        updateQuestion(question.id, { scale: { min, max: prev.max ?? 5 } });
                                    }}
                                />
                            </div>
                            <div className="space-y-2">
                                <Label>Maximum Value</Label>
                                <Input
                                    type="number"
                                    value={question.scale?.max || 5}
                                    onChange={(e) => {
                                        const max = parseInt(e.target.value);
                                        const prev = question.scale || { min: 1, max: 5 };
                                        updateQuestion(question.id, { scale: { min: prev.min ?? 1, max } });
                                    }}
                                />
                            </div>
                        </div>
                    )}
                </CardContent>
            </Card>
        )
    }

    return (
        <div className="space-y-6">
            {/* Question Types */}
            <Card>
                <CardHeader>
                    <CardTitle>Add Questions</CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-2">
                        <Button
                            variant="outline"
                            onClick={() => addQuestion('short_text')}
                            className="h-20 flex-col"
                        >
                            <Type className="h-4 w-4 mb-1" />
                            <span className="text-xs">Short Text</span>
                        </Button>
                        <Button
                            variant="outline"
                            onClick={() => addQuestion('long_text')}
                            className="h-20 flex-col"
                        >
                            <Type className="h-4 w-4 mb-1" />
                            <span className="text-xs">Long Text</span>
                        </Button>
                        <Button
                            variant="outline"
                            onClick={() => addQuestion('single_choice')}
                            className="h-20 flex-col"
                        >
                            <Type className="h-4 w-4 mb-1" />
                            <span className="text-xs">Single Choice</span>
                        </Button>
                        <Button
                            variant="outline"
                            onClick={() => addQuestion('multi_choice')}
                            className="h-20 flex-col"
                        >
                            <Type className="h-4 w-4 mb-1" />
                            <span className="text-xs">Multiple Choice</span>
                        </Button>
                        <Button
                            variant="outline"
                            onClick={() => addQuestion('scale')}
                            className="h-20 flex-col"
                        >
                            <Type className="h-4 w-4 mb-1" />
                            <span className="text-xs">Scale</span>
                        </Button>
                        <Button
                            variant="outline"
                            onClick={() => addQuestion('date')}
                            className="h-20 flex-col"
                        >
                            <Type className="h-4 w-4 mb-1" />
                            <span className="text-xs">Date</span>
                        </Button>
                        <Button
                            variant="outline"
                            onClick={() => addQuestion('yes_no')}
                            className="h-20 flex-col"
                        >
                            <Type className="h-4 w-4 mb-1" />
                            <span className="text-xs">Yes/No</span>
                        </Button>
                    </div>
                </CardContent>
            </Card>

            {/* Questions List */}
            <Card>
                <CardHeader>
                    <CardTitle>Questions ({questions.length})</CardTitle>
                </CardHeader>
                <CardContent>
                    {questions.length === 0 ? (
                        <div className="text-center py-8">
                            <Type className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                            <h3 className="text-lg font-medium text-gray-900 mb-2">No questions yet</h3>
                            <p className="text-gray-500">Add questions to your survey using the buttons above.</p>
                        </div>
                    ) : (
                        <DragDropContext onDragEnd={handleDragEnd}>
                            <Droppable droppableId="questions">
                                {(provided) => (
                                    <div
                                        {...provided.droppableProps}
                                        ref={provided.innerRef}
                                        className="space-y-4"
                                    >
                                        {questions.map((question, index) => (
                                            <Draggable key={question.id} draggableId={question.id} index={index}>
                                                {(provided) => (
                                                    <div
                                                        ref={provided.innerRef}
                                                        {...provided.draggableProps}
                                                        className="border rounded-lg p-4 bg-white"
                                                    >
                                                        <div className="flex items-center gap-2 mb-4">
                                                            <div {...provided.dragHandleProps}>
                                                                <GripVertical className="h-4 w-4 text-gray-400" />
                                                            </div>
                                                            <span className="text-sm font-medium">
                                                                Question {question.order}
                                                            </span>
                                                            <Badge variant="secondary">
                                                                {getQuestionTypeLabel(question.type)}
                                                            </Badge>
                                                            {question.required && (
                                                                <Badge variant="destructive">Required</Badge>
                                                            )}
                                                        </div>
                                                        {renderQuestionEditor(question)}
                                                    </div>
                                                )}
                                            </Draggable>
                                        ))}
                                        {provided.placeholder}
                                    </div>
                                )}
                            </Droppable>
                        </DragDropContext>
                    )}
                </CardContent>
            </Card>
        </div>
    )
}





