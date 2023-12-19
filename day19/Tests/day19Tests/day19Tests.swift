import Foundation
import XCTest
@testable import day19

final class day19Tests: XCTestCase {
    let exampleInput =
    """
    px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}
    """
    
    func test_extractWorkflows_withExampleInput() {
        let workflows = extractWorkflows(exampleInput)
        XCTAssertEqual(workflows.count, 11)
    }
    
    func test_workflow_fromString() {
        let workflowString = "ex{x>10:one,m<20:two,a>30:R,A}"
        let workflow = Workflow(workflowString)
        
        XCTAssertEqual(workflow.name, "ex")
        XCTAssertEqual(workflow.rules.count, 4)
        print(workflow.rules)
    }
    
    func test_rule_comparator_fromString() {
        let ruleString = "x>10:one"
        let rule = Rule(ruleString)
        XCTAssertEqual(rule.property, "x")
        XCTAssertEqual(rule.comparator, ">")
        XCTAssertEqual(rule.treshold, 10)
        XCTAssertEqual(rule.redirect, "one")
    }
    
    func test_rule_comparator2_fromString() {
        let ruleString = "m<25:R"
        let rule = Rule(ruleString)
        XCTAssertEqual(rule.property, "m")
        XCTAssertEqual(rule.comparator, "<")
        XCTAssertEqual(rule.treshold, 25)
        XCTAssertEqual(rule.redirect, "R")
    }
    
    func test_rule_unconditionalRedirect_fromString() {
        let ruleString = "one"
        let rule = Rule(ruleString)
        XCTAssertEqual(rule.property, nil)
        XCTAssertEqual(rule.comparator, nil)
        XCTAssertEqual(rule.treshold, nil)
        XCTAssertEqual(rule.redirect, "one")
    }
    
    func test_rule_evaluate_forUnconditionalAccept() {
        let ruleString = "A"
        let rule = Rule(ruleString)
        let part = Part()
        let result = rule.evaluate(part)
        XCTAssertEqual(result, .accepted)
    }
    
    func test_rule_evaluate_forUnconditionalReject() {
        let ruleString = "R"
        let rule = Rule(ruleString)
        let part = Part()
        let result = rule.evaluate(part)
        XCTAssertEqual(result, .rejected)
    }
    
    func test_rule_evaluate_forUnconditionalRedirect() {
        let ruleString = "ABC"
        let rule = Rule(ruleString)
        let part = Part()
        let result = rule.evaluate(part)
        XCTAssertEqual(result, .redirect("ABC"))
    }
    
    func test_rule_evaluate_forConditional_passes_whenDoesntMatch() {
        let ruleString = "m>10:A"
        let rule = Rule(ruleString)
        let part = Part()
        let result = rule.evaluate(part)
        XCTAssertEqual(result, .pass)
    }
    
    func test_rule_evaluate_forConditional_accepts_whenMatch() {
        let ruleString = "m>10:A"
        let rule = Rule(ruleString)
        let part = Part(properties: ["m": 11])
        let result = rule.evaluate(part)
        XCTAssertEqual(result, .accepted)
    }
    
    func test_workflow_forASingleExampleWorkflow() {
        let workflow = Workflow("ex{x>10:one,m<20:two,a>30:R,A}")
        let expected: [Rule.Result] = [
            .redirect("one"),
            .redirect("two"),
            .rejected,
            .accepted
        ]
        
        let inputParts = [
            Part(properties: ["x": 20, "m": 0, "a": 0, "s": 0]),
            Part(properties: ["x": 0, "m": 0, "a": 0, "s": 0]),
            Part(properties: ["x": 0, "m": 30, "a": 40, "s": 0]),
            Part(properties: ["x": 0, "m": 30, "a": 20, "s": 0]),
        ]
        
        for i in 0 ..< 4 {
            let result = workflow.evaluate(inputParts[i])
            XCTAssertEqual(result, expected[i])
        }
    }
    
    func test_part_createFromString() {
        let partString = "{x=787,m=2655,a=1222,s=2876}"
        let part = Part(partString)
        XCTAssertEqual(part.properties["x"], 787)
        XCTAssertEqual(part.properties["m"], 2655)
        XCTAssertEqual(part.properties["a"], 1222)
        XCTAssertEqual(part.properties["s"], 2876)
    }
    
    func test_extractParts_withExampleInput() {
        let parts = extractParts(exampleInput)
        XCTAssertEqual(parts.count, 5)
    }
    
    func test_processPart_withExampleInput() {
        let expected = [
            true,
            false,
            true,
            false,
            true
        ]
                
        let workflows = extractWorkflows(exampleInput)
        let parts = extractParts(exampleInput)
        
        XCTAssertEqual(parts.count, expected.count)
        
        for i in 0 ..< parts.count {
            XCTAssertEqual(processPart(parts[i], in: workflows), expected[i], "part: \(parts[i]), expected: \(expected[i])")
        }
    }
    
    func test_processPart_withExampleInput_specificCase() {
        let workflows = extractWorkflows(exampleInput)
                
        let part = Part("{x=2036,m=264,a=79,s=2244}")
        XCTAssertEqual(processPart(part, in: workflows), true, "part: \(part), expected: true")
    }
    
    func test_getAcceptedPartsSum_withExampleInput() {
        let result = getAcceptedPartsSum(exampleInput)
        XCTAssertEqual(result, 19114)
    }
    
    func test_part1() {
        let result = getAcceptedPartsSum(input)
        XCTAssertEqual(result, 389114)
    }
    
    // MARK: Part 2
    func test_splitWorkflow() {
        let workflow = Workflow("px{a<2006:qkq,m>2090:A,rfg}")
        let expected = [
            "px1{a<2006:qkq1,px2}",
            "px2{m>2090:A,rfg1}"
        ]
        
        let result = workflow.split()
        XCTAssertEqual(result.count, expected.count)
        for i in 0 ..< result.count {
            XCTAssertEqual(result[i].workflowString, expected[i])
        }
    }
    
    func test_splitWorkflow_forExampleInput() {
        let expected =
        """
        px1{a<2006:qkq1,px2}
        px2{m>2090:A,rfg1}
        pv1{a>1716:R,A}
        lnx1{m>1548:A,A}
        rfg1{s<537:gd1,rfg2}
        rfg2{x>2440:R,A}
        qs1{s>3448:A,lnx1}
        qkq1{x<1416:A,crn1}
        crn1{x>2662:A,R}
        in{s<1351:px1,qqz1}
        qqz1{s>2770:qs1,qqz2}
        qqz2{m<1801:hdj1,R}
        gd1{a>3333:R,R}
        hdj1{m>838:A,pv1}
        """.split(separator: "\n").map { String($0) }
        
        let workflows = extractWorkflows(exampleInput)
        let expandedWorkflows = workflows.flatMap { $0.split() }
        
        XCTAssertEqual(expandedWorkflows.count, expected.count)
        
        for i in 0 ..< expected.count {
            let result = expandedWorkflows[i].workflowString
            XCTAssertTrue(expected.contains(result), "Could not find \(result) in expected")
        }
        
    }
    
    func test_getSum_withExampleInput() {
        let result = getSum(exampleInput)
        XCTAssertEqual(result, 167409079868000)
    }
    
    func test_part2() {
        let result = getSum(input)
        XCTAssertEqual(result, 125051049836302)
    }
}
